namespace CandleCore.Models.Note;

public class CreateNoteModel
{
    public int?   AssetId { get; set; }
    public string Title   { get; set; } = string.Empty;
    public string Body    { get; set; } = string.Empty;
}
