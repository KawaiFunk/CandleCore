using Npgsql;

namespace CandleCore.Infrastructure.Persistence.MigrationService;

public class MigrationService(string migrationsPath, string connectionString)
{
    public async Task ApplyMigrationsAsync()
    {
        await using var connection = new NpgsqlConnection(connectionString);
        await connection.OpenAsync();

        await using (var cmd = new NpgsqlCommand(
                         @"CREATE TABLE IF NOT EXISTS migration_history (
                id SERIAL PRIMARY KEY,
                filename VARCHAR(255) NOT NULL,
                applied_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
            );", connection))
        {
            await cmd.ExecuteNonQueryAsync();
        }

        var applied = new HashSet<string>();
        await using (var cmd = new NpgsqlCommand("SELECT filename FROM migration_history", connection))
        await using (var reader = await cmd.ExecuteReaderAsync())
        {
            while (await reader.ReadAsync())
                applied.Add(reader.GetString(0));
        }

        var files = Directory.GetFiles(migrationsPath, "*.sql")
            .OrderBy(f => f);

        foreach (var file in files)
        {
            var filename = Path.GetFileName(file);
            if (applied.Contains(filename)) continue;

            var sql = await File.ReadAllTextAsync(file);
            await using (var cmd = new NpgsqlCommand(sql, connection))
            {
                await cmd.ExecuteNonQueryAsync();
            }

            await using (var cmd = new NpgsqlCommand("INSERT INTO migration_history (filename) VALUES (@filename)", connection))
            {
                cmd.Parameters.AddWithValue("filename", filename);
                await cmd.ExecuteNonQueryAsync();
            }
        }
    }
}