using CandleCore.Application.Exceptions;
using CandleCore.Domain.Entities.User;
using CandleCore.Infrastructure.Services.Generic;
using CandleCore.Interfaces.Repositories.Generic;
using CandleCore.Interfaces.Repositories.User;
using CandleCore.Interfaces.Services.User;
using CandleCore.Models.User;

namespace CandleCore.Infrastructure.Services.User;

public class UserService(
    IGenericRepository<UserEntity> repository,
    IUserRepository                userRepository)
    : GenericService<UserEntity>(repository), IUserService
{
    public async Task<UserModel> RegisterAsync(RegisterRequest request)
    {
        if (await userRepository.UsernameExistsAsync(request.Username))
            throw new DuplicateResourceException("User", "username", request.Username);

        if (await userRepository.EmailExistsAsync(request.Email))
            throw new DuplicateResourceException("User", "email", request.Email);

        var entity = new UserEntity
        {
            Username = request.Username,
            Email    = request.Email,
            Password = BCrypt.Net.BCrypt.HashPassword(request.Password, workFactor: 12, enhancedEntropy: false)
        };

        await userRepository.AddAsync(entity);

        return new UserModel
        {
            Id       = entity.Id,
            Username = entity.Username,
            Email    = entity.Email
        };
    }

    public async Task<UserModel> LoginAsync(LoginRequest request)
    {
        var user = await userRepository.GetByUsernameAsync(request.Username);

        if (user == null || !BCrypt.Net.BCrypt.Verify(request.Password, user.Password, enhancedEntropy: false))
            throw new InvalidCredentialsException();

        return new UserModel
        {
            Id       = user.Id,
            Username = user.Username,
            Email    = user.Email
        };
    }
}
