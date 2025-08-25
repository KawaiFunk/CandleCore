using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace CandleCore.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class InitialCreate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.EnsureSchema(
                name: "Assets");

            migrationBuilder.CreateTable(
                name: "Assets",
                schema: "Assets",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    ExternalId = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    Symbol = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: false),
                    Name = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    Rank = table.Column<int>(type: "integer", nullable: false),
                    PriceUsd = table.Column<decimal>(type: "numeric(18,8)", nullable: false),
                    PercentChange24h = table.Column<decimal>(type: "numeric(18,4)", nullable: false),
                    PercentChange1h = table.Column<decimal>(type: "numeric(18,4)", nullable: false),
                    PercentChange7d = table.Column<decimal>(type: "numeric(18,4)", nullable: false),
                    PriceBtc = table.Column<decimal>(type: "numeric(18,8)", nullable: false),
                    MarketCapUsd = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    Volume24a = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    CreatedAtUtc = table.Column<DateTime>(type: "timestamp with time zone", nullable: false, defaultValueSql: "NOW()"),
                    UpdatedAtUtc = table.Column<DateTime>(type: "timestamp with time zone", nullable: false, defaultValueSql: "NOW()")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Assets", x => x.Id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Assets_ExternalId",
                schema: "Assets",
                table: "Assets",
                column: "ExternalId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Assets_Symbol",
                schema: "Assets",
                table: "Assets",
                column: "Symbol",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Assets",
                schema: "Assets");
        }
    }
}
