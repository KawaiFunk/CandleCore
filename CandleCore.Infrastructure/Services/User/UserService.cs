using CandleCore.Domain.Entities.User;
using CandleCore.Exceptions;
using CandleCore.Infrastructure.Services.Generic;
using CandleCore.Interfaces.Repositories.Generic;
using CandleCore.Interfaces.Repositories.User;
using CandleCore.Interfaces.Services;
using CandleCore.Interfaces.Services.User;
using CandleCore.Mappers;
using CandleCore.Models.User;

namespace CandleCore.Infrastructure.Services.User;

public class UserService(
    IGenericRepository<UserEntity> repository,
    IUserRepository                userRepository,
    IUserMapper                    userMapper,
    ICryptService                  cryptService)
    : GenericService<UserEntity>(repository), IUserService
{
    public async Task<UserModel> RegisterAsync(RegisterRequest request)
    {
        if (await userRepository.UsernameExistsAsync(request.Username))
            throw new DuplicateResourceException("User", "username", request.Username);

        if (await userRepository.EmailExistsAsync(request.Email))
            throw new DuplicateResourceException("User", "email", request.Email);

        var entity = userMapper.ToEntity(request, cryptService.Hash(request.Password));

        await userRepository.AddAsync(entity);

        return userMapper.Map(entity);
    }

    public async Task<UserModel> LoginAsync(LoginRequest request)
    {
        var user = await userRepository.GetByUsernameAsync(request.Username);

        if (user == null || !cryptService.Verify(request.Password, user.Password))
            throw new InvalidCredentialsException();

        return userMapper.Map(user);
    }
}
