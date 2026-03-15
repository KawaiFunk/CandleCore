using CandleCore.Domain.Entities.User;
using CandleCore.Interfaces.Services.Generic;
using CandleCore.Models.User;

namespace CandleCore.Interfaces.Services.User;

public interface IUserService : IGenericService<UserEntity>
{
    Task<UserModel>  RegisterAsync(RegisterRequest request);
    Task<UserModel?> LoginAsync(LoginRequest request);
}
