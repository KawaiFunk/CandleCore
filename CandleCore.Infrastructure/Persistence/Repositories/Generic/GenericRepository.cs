using CandleCore.Domain.Common.PagedList;
using CandleCore.Domain.Entities.Generic;
using CandleCore.Infrastructure.Helpers.PagedList;
using CandleCore.Interfaces.Repositories.Generic;
using Domain.Common.PagedList;
using Microsoft.EntityFrameworkCore;

namespace CandleCore.Infrastructure.Persistence.Repositories.Generic;

public class GenericRepository<T> : IGenericRepository<T> where T : BaseEntity
{
    private readonly CandleCoreDbContext _context;
    private readonly DbSet<T>            _dbSet;

    public IQueryable<T> Table => _dbSet.AsQueryable();

    public GenericRepository(CandleCoreDbContext context)
    {
        _context = context;
        _dbSet   = _context.Set<T>();
    }

    public async Task<T?> GetByIdAsync(int id)
    {
        return await Table.FirstOrDefaultAsync(e => e.Id == id);
    }

    public async Task<List<T>> GetAllAsync()
    {
        return await Table.ToListAsync();
    }

    public async Task<IPagedList<T>> GetAllPagedAsync(PagedListFilter filter)
    {
        return await Table.AsNoTracking().ToPagedListAsync(filter);
    }

    public async Task AddAsync(T entity)
    {
        await _context.AddAsync(entity);
        await _context.SaveChangesAsync();
    }

    public async Task UpdateAsync(T entity)
    {
        _context.Update(entity);
        await _context.SaveChangesAsync();
    }

    public async Task DeleteAsync(int id)
    {
        var entity = await Table.FirstOrDefaultAsync(e => e.Id == id);
        if (entity != null)
        {
            _context.Remove(entity);
            await _context.SaveChangesAsync();
        }
    }

    public async Task<bool> ExistsAsync(int id)
    {
        return await Table.AnyAsync(e => e.Id == id);
    }

    public async Task AddRangeAsync(IEnumerable<T> entities)
    {
        await _context.AddRangeAsync(entities);
        await _context.SaveChangesAsync();
    }
}