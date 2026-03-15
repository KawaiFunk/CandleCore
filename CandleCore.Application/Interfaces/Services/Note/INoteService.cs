using CandleCore.Models.Note;

namespace CandleCore.Interfaces.Services.Note;

public interface INoteService
{
    Task<List<NoteModel>> GetByUserIdAsync(int userId);
    Task<NoteModel>       CreateAsync(int userId, CreateNoteModel model);
    Task                  DeleteAsync(int userId, int noteId);
}
