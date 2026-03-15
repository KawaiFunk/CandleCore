namespace CandleCore.Models.Note;

public class NoteModel
{
    public int      Id           { get; set; }
    public int      UserId       { get; set; }
    public int?     AssetId      { get; set; }
    public string?  AssetSymbol  { get; set; }
    public string?  AssetName    { get; set; }
    public string   Title        { get; set; } = string.Empty;
    public string   Body         { get; set; } = string.Empty;
    public DateTime CreatedAtUtc { get; set; }
    public DateTime UpdatedAtUtc { get; set; }
}
