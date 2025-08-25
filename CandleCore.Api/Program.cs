using CandleCore.Infrastructure.Configurations;
using CandleCore.Infrastructure.Handlers.Asset;
using CandleCore.Infrastructure.Mappers;
using CandleCore.Infrastructure.Persistence.Repositories;
using CandleCore.Infrastructure.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

//Add Swagger
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

//Add MediatR
builder.Services.AddMediatR(cfg
    => cfg.RegisterServicesFromAssemblyContaining<GetAllAssetsRequestHandler>());

//Inject custom services
builder.Services.AddServices();
builder.Services.AddRepositories();
builder.Services.AddMappers();

//Add DbContext
builder.Services.AddDbContextConfiguration(
    builder.Configuration.GetConnectionString("DefaultConnection"));

builder.Services.AddControllers();
// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
builder.Services.AddOpenApi();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();