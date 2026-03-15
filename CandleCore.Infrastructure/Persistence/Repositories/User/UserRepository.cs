using CandleCore.Domain.Entities.User;
using CandleCore.Infrastructure.Persistence.Repositories.Generic;
using CandleCore.Interfaces.Repositories.User;
using Microsoft.EntityFrameworkCore;

namespace CandleCore.Infrastructure.Persistence.Repositories.User;

public class UserRepository(CandleCoreDbContext context) : GenericRepository<UserEntity>(context), IUserRepository
{
    public async Task<UserEntity?> GetByUsernameAsync(string username)
        => await Table.FirstOrDefaultAsync(u => u.Username == username);

    public async Task<UserEntity?> GetByEmailAsync(string email)
        => await Table.FirstOrDefaultAsync(u => u.Email == email);

    public async Task<bool> UsernameExistsAsync(string username)
        => await Table.AnyAsync(u => u.Username == username);

    public async Task<bool> EmailExistsAsync(string email)
        => await Table.AnyAsync(u => u.Email == email);
}
