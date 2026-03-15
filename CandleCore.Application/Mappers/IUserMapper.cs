using CandleCore.Domain.Entities.User;
using CandleCore.Models.User;

namespace CandleCore.Mappers;

public interface IUserMapper
{
    UserModel  Map(UserEntity      entity);
    UserEntity ToEntity(RegisterRequest request, string hashedPassword);
}
