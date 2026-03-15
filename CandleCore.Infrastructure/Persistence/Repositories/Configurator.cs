using CandleCore.Infrastructure.Persistence.Repositories.Asset;
using CandleCore.Infrastructure.Persistence.Repositories.Favorite;
using CandleCore.Infrastructure.Persistence.Repositories.Generic;
using CandleCore.Infrastructure.Persistence.Repositories.Note;
using CandleCore.Infrastructure.Persistence.Repositories.User;
using CandleCore.Interfaces.Repositories.Asset;
using CandleCore.Interfaces.Repositories.Favorite;
using CandleCore.Interfaces.Repositories.Generic;
using CandleCore.Interfaces.Repositories.Note;
using CandleCore.Interfaces.Repositories.User;
using Microsoft.Extensions.DependencyInjection;

namespace CandleCore.Infrastructure.Persistence.Repositories;

public static class Configurator
{
    public static void AddRepositories(this IServiceCollection services)
    {
        services.AddScoped(typeof(IGenericRepository<>), typeof(GenericRepository<>));
        services.AddScoped<IAssetRepository, AssetRepository>();
        services.AddScoped<IUserRepository, UserRepository>();
        services.AddScoped<IFavoriteRepository, FavoriteRepository>();
        services.AddScoped<INoteRepository, NoteRepository>();
    }
}