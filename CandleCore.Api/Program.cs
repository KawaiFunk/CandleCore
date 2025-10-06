using CandleCore.Infrastructure.Extensions;
using Hangfire;
using Serilog;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddCandleCoreServices(builder.Configuration);
builder.Services.AddOpenApi();
builder.Services.AddSwaggerGen();


builder.Host.UseSerilog((context, configuration) =>
    configuration.ReadFrom.Configuration(context.Configuration));

var app = builder.Build();

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
}

await app.UseCandleCoreStartupAsync();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
    app.MapOpenApi();
}

app.UseSerilogRequestLogging();
app.UseHangfireDashboard("/hangfire");
app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();
app.Run();