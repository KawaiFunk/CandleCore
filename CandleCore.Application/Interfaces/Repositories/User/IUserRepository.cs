using CandleCore.Domain.Entities.User;
using CandleCore.Interfaces.Repositories.Generic;

namespace CandleCore.Interfaces.Repositories.User;

public interface IUserRepository : IGenericRepository<UserEntity>
{
    Task<UserEntity?> GetByUsernameAsync(string username);
    Task<UserEntity?> GetByEmailAsync(string email);
    Task<bool>        UsernameExistsAsync(string username);
    Task<bool>        EmailExistsAsync(string email);
}
