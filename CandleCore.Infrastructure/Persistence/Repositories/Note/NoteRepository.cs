using CandleCore.Domain.Entities.Asset;
using CandleCore.Domain.Entities.Note;
using CandleCore.Interfaces.Repositories.Note;
using Microsoft.EntityFrameworkCore;

namespace CandleCore.Infrastructure.Persistence.Repositories.Note;

public class NoteRepository(CandleCoreDbContext context) : INoteRepository
{
    public async Task<List<NoteEntity>> GetByUserIdAsync(int userId)
    {
        return await context.Set<NoteEntity>()
            .Where(n => n.UserId == userId)
            .OrderByDescending(n => n.CreatedAtUtc)
            .AsNoTracking()
            .ToListAsync();
    }

    public async Task<NoteEntity?> GetByIdAsync(int id)
    {
        return await context.Set<NoteEntity>()
            .FirstOrDefaultAsync(n => n.Id == id);
    }

    public async Task<NoteEntity> CreateAsync(NoteEntity note)
    {
        context.Set<NoteEntity>().Add(note);
        await context.SaveChangesAsync();
        return note;
    }

    public async Task DeleteAsync(NoteEntity note)
    {
        context.Set<NoteEntity>().Remove(note);
        await context.SaveChangesAsync();
    }

    public async Task<(string Symbol, string Name)?> GetAssetInfoAsync(int assetId)
    {
        var asset = await context.Set<AssetEntity>()
            .Where(a => a.Id == assetId)
            .Select(a => new { a.Symbol, a.Name })
            .FirstOrDefaultAsync();

        return asset == null ? null : (asset.Symbol, asset.Name);
    }
}
