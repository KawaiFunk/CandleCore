using CandleCore.Domain.Entities.Generic;

namespace CandleCore.Domain.Entities.User;

public class DeviceTokenEntity : BaseEntity
{
    public int    UserId { get; set; }
    public string Token  { get; set; } = string.Empty;
}
