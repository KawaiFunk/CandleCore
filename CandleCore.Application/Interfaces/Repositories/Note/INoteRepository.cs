using CandleCore.Domain.Entities.Note;

namespace CandleCore.Interfaces.Repositories.Note;

public interface INoteRepository
{
    Task<List<NoteEntity>> GetByUserIdAsync(int userId);
    Task<NoteEntity?>      GetByIdAsync(int id);
    Task<NoteEntity>       CreateAsync(NoteEntity note);
    Task                           DeleteAsync(NoteEntity note);
    Task<(string Symbol, string Name)?> GetAssetInfoAsync(int assetId);
}
