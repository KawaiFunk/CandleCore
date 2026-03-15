using CandleCore.Domain.Entities.Note;
using CandleCore.Interfaces.Repositories.Note;
using CandleCore.Interfaces.Services.Note;
using CandleCore.Models.Note;

namespace CandleCore.Infrastructure.Services.Note;

public class NoteService(INoteRepository noteRepository) : INoteService
{
    public async Task<List<NoteModel>> GetByUserIdAsync(int userId)
    {
        var entities = await noteRepository.GetByUserIdAsync(userId);

        var models = new List<NoteModel>(entities.Count);
        foreach (var entity in entities)
        {
            (string Symbol, string Name)? assetInfo = null;
            if (entity.AssetId.HasValue)
                assetInfo = await noteRepository.GetAssetInfoAsync(entity.AssetId.Value);

            models.Add(MapToModel(entity, assetInfo));
        }

        return models;
    }

    public async Task<NoteModel> CreateAsync(int userId, CreateNoteModel model)
    {
        var entity = new NoteEntity
        {
            UserId  = userId,
            AssetId = model.AssetId,
            Title   = model.Title,
            Body    = model.Body,
        };

        var created = await noteRepository.CreateAsync(entity);

        (string Symbol, string Name)? assetInfo = null;
        if (created.AssetId.HasValue)
            assetInfo = await noteRepository.GetAssetInfoAsync(created.AssetId.Value);

        return MapToModel(created, assetInfo);
    }

    public async Task DeleteAsync(int userId, int noteId)
    {
        var note = await noteRepository.GetByIdAsync(noteId);
        if (note == null || note.UserId != userId) return;
        await noteRepository.DeleteAsync(note);
    }

    private static NoteModel MapToModel(NoteEntity entity, (string Symbol, string Name)? assetInfo) =>
        new()
        {
            Id           = entity.Id,
            UserId       = entity.UserId,
            AssetId      = entity.AssetId,
            AssetSymbol  = assetInfo?.Symbol,
            AssetName    = assetInfo?.Name,
            Title        = entity.Title,
            Body         = entity.Body,
            CreatedAtUtc = entity.CreatedAtUtc,
            UpdatedAtUtc = entity.UpdatedAtUtc,
        };
}
