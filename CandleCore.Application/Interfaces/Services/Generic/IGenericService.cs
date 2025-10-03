using CandleCore.Domain.Entities.Generic;
using Domain.Common.PagedList;

namespace CandleCore.Interfaces.Services.Generic;

public interface IGenericService<T> where T : BaseEntity
{
    Task<List<T>>       GetAllAsync();
    Task<T?>             GetByIdAsync(int                 id);
    Task<IPagedList<T>> GetAllPagedAsync(PagedListFilter filter);
    Task                AddAsync(T                       entity);
    Task                UpdateAsync(T                    entity);
    Task                DeleteAsync(int                  id);
    Task<bool>          ExistsAsync(int                  id);
    Task                AddRangeAsync(IEnumerable<T>     entities);
}