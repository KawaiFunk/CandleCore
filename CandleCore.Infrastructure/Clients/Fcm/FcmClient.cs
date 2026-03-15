using System.Text;
using System.Text.Json;
using CandleCore.Infrastructure.Options.Fcm;
using CandleCore.Interfaces.Clients;
using Google.Apis.Auth.OAuth2;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace CandleCore.Infrastructure.Clients.Fcm;

public class FcmClient(
    IHttpClientFactory         httpClientFactory,
    IOptions<FcmOptions>       options,
    ILogger<FcmClient>         logger) : IFcmClient
{
    public async Task SendAsync(string deviceToken, string title, string body)
    {
        try
        {
            var projectId = options.Value.ProjectId;
            var serviceAccountJson = options.Value.ServiceAccountJson;

            if (string.IsNullOrWhiteSpace(projectId) || string.IsNullOrWhiteSpace(serviceAccountJson))
                return;

            var credential = GoogleCredential
                .FromJson(serviceAccountJson)
                .CreateScoped("https://www.googleapis.com/auth/firebase.messaging");

            var accessToken = await credential.UnderlyingCredential
                .GetAccessTokenForRequestAsync();

            var payload = new
            {
                message = new
                {
                    token        = deviceToken,
                    notification = new { title, body },
                }
            };

            var json    = JsonSerializer.Serialize(payload);
            var content = new StringContent(json, Encoding.UTF8, "application/json");

            var client  = httpClientFactory.CreateClient("fcm");
            var url     = $"https://fcm.googleapis.com/v1/projects/{projectId}/messages:send";
            var request = new HttpRequestMessage(HttpMethod.Post, url)
            {
                Content = content,
            };
            request.Headers.Authorization =
                new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", accessToken);

            var response     = await client.SendAsync(request);
            var responseBody = await response.Content.ReadAsStringAsync();

            if (!response.IsSuccessStatusCode)
                logger.LogWarning("FCM returned {StatusCode} for token {Token}. Body: {Body}",
                    response.StatusCode, deviceToken, responseBody);
            else
                logger.LogInformation("FCM notification sent successfully to token {Token}", deviceToken);
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Failed to send FCM notification to {Token}", deviceToken);
        }
    }
}
