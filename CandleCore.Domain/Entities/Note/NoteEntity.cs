using CandleCore.Domain.Entities.Generic;

namespace CandleCore.Domain.Entities.Note;

public class NoteEntity : BaseEntity
{
    public int     UserId  { get; set; }
    public int?    AssetId { get; set; }
    public string  Title   { get; set; } = string.Empty;
    public string  Body    { get; set; } = string.Empty;
}
