using CandleCore.Domain.Entities.User;
using CandleCore.Mappers;
using CandleCore.Models.User;

namespace CandleCore.Infrastructure.Mappers.User;

public class UserMapper : IUserMapper
{
    public UserModel Map(UserEntity entity) => new()
    {
        Id       = entity.Id,
        Username = entity.Username,
        Email    = entity.Email
    };

    public UserEntity ToEntity(RegisterRequest request, string hashedPassword) => new()
    {
        Username = request.Username,
        Email    = request.Email,
        Password = hashedPassword
    };
}
