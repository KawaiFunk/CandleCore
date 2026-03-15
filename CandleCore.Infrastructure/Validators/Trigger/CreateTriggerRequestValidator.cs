using CandleCore.Infrastructure.Handlers.Trigger;
using CandleCore.Interfaces.Repositories.Trigger;
using CandleCore.Models.Trigger.Enum;
using FluentValidation;

namespace CandleCore.Infrastructure.Validators.Trigger;

public class CreateTriggerRequestValidator : AbstractValidator<CreateTriggerRequest>
{
    public CreateTriggerRequestValidator(ITriggerRepository triggerRepository)
    {
        RuleFor(r => r.Model.AssetId)
            .GreaterThan(0)
            .WithMessage("A valid asset must be selected.");

        RuleFor(r => r.Model.TargetPrice)
            .GreaterThan(0)
            .WithMessage("Target price must be greater than zero.");

        RuleFor(r => r)
            .MustAsync(async (request, _) =>
            {
                var price = await triggerRepository.GetCurrentPriceAsync(request.Model.AssetId);
                if (price is null) return true;

                return request.Model.Condition switch
                {
                    AlarmCondition.Above => price < request.Model.TargetPrice,
                    AlarmCondition.Below => price > request.Model.TargetPrice,
                    _                   => true,
                };
            })
            .WithMessage(request =>
            {
                var direction = request.Model.Condition == AlarmCondition.Above ? "above" : "below";
                return $"The current price is already {direction} your target. Choose a different target price or condition.";
            });
    }
}
