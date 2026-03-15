using CandleCore.Domain.Entities.Note;
using CandleCore.Infrastructure.Persistence.DbConstants;
using CandleCore.Infrastructure.Persistence.Helpers;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace CandleCore.Infrastructure.Persistence.Configurations;

public class NoteEntityTypeConfiguration : IEntityTypeConfiguration<NoteEntity>
{
    public void Configure(EntityTypeBuilder<NoteEntity> builder)
    {
        builder.HasAllPropertiesSnakeCase();

        builder.ToTable(DatabaseTables.Notes, DatabaseSchemas.Notes);

        builder.HasKey(n => n.Id);

        builder.Property(n => n.UserId).IsRequired();

        builder.Property(n => n.AssetId).IsRequired(false);

        builder.Property(n => n.Title)
            .IsRequired()
            .HasMaxLength(200);

        builder.Property(n => n.Body)
            .IsRequired()
            .HasMaxLength(4000);

        builder.Property(n => n.CreatedAtUtc)
            .HasDefaultValueSql("NOW()")
            .ValueGeneratedOnAdd();

        builder.Property(n => n.UpdatedAtUtc)
            .HasDefaultValueSql("NOW()")
            .ValueGeneratedOnAddOrUpdate();

        builder.HasIndex(n => n.UserId);
        builder.HasIndex(n => n.AssetId);
    }
}
