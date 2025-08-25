using CandleCore.Domain.Entities.Generic;
using CandleCore.Interfaces.Repositories.Generic;
using CandleCore.Interfaces.Services.Generic;
using Domain.Common.PagedList;

namespace CandleCore.Infrastructure.Services.Generic;

public class GenericService<T>(IGenericRepository<T> repository) : IGenericService<T>
    where T : BaseEntity
{
    public async Task<T?> GetByIdAsync(int id)
    {
        return await repository.GetByIdAsync(id);
    }

    public async Task<IPagedList<T>> GetAllPagedAsync(PagedListFilter filter)
    {
        return await repository.GetAllPagedAsync(filter);
    }

    public async Task AddAsync(T entity)
    {
        await repository.AddAsync(entity);
    }

    public async Task UpdateAsync(T entity)
    {
        await repository.UpdateAsync(entity);
    }

    public async Task DeleteAsync(int id)
    {
        await repository.DeleteAsync(id);
    }

    public async Task<bool> ExistsAsync(int id)
    {
        return await repository.ExistsAsync(id);
    }

    public async Task AddRangeAsync(IEnumerable<T> entities)
    {
        await repository.AddRangeAsync(entities);
    }

    public async Task<List<T>> GetAllAsync()
    {
        return await repository.GetAllAsync();
    }
}