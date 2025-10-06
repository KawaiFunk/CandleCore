using System.Text;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace CandleCore.Infrastructure.Persistence.Helpers
{
    public static class EntityTypeBuilderExtensions
    {
        public static void HasAllPropertiesSnakeCase<T>(this EntityTypeBuilder<T> builder) where T : class
        {
            foreach (var property in builder.Metadata.GetProperties())
            {
                var snakeCaseName = ToSnakeCase(property.Name);
                builder.Property(property.Name).HasColumnName(snakeCaseName);
            }
        }

        private static string ToSnakeCase(string input)
        {
            if (string.IsNullOrEmpty(input)) return input;
            var sb = new StringBuilder();
            for (var i = 0; i < input.Length; i++)
            {
                var c = input[i];
                if (char.IsUpper(c))
                {
                    if (i > 0) sb.Append('_');
                    sb.Append(char.ToLowerInvariant(c));
                }
                else if (char.IsDigit(c))
                {
                    if (i > 0 && char.IsLetter(input[i - 1])) sb.Append('_');
                    sb.Append(c);
                }
                else
                {
                    sb.Append(c);
                }
            }
            return sb.ToString();
        }
    }
}