using Bogus;
using Microsoft.AspNetCore.Mvc;
using static Bogus.DataSets.Name;

namespace ConnectorAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class WeatherForecastController : ControllerBase
    {
        private static readonly string[] Summaries = new[]
        {
        "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
    };

        private readonly ILogger<WeatherForecastController> _logger;

        public WeatherForecastController(ILogger<WeatherForecastController> logger)
        {
            _logger = logger;
        }

        [HttpGet(Name = "GetWeatherForecast")]
        public IEnumerable<WeatherForecast> Get()
        {
            return Enumerable.Range(1, 5).Select(index => new WeatherForecast
            {
                Date = DateTime.Now.AddDays(index),
                TemperatureC = Random.Shared.Next(-20, 55),
                Summary = Summaries[Random.Shared.Next(Summaries.Length)]
            })
            .ToArray();
        }

        [HttpGet("Log")]
        public IEnumerable<LogDataEntity> LogData()
        {
            Random random = new Random();
            int logCount = random.Next(1, 10);

            Faker<LogDataEntity> faker = new Faker<LogDataEntity>().RuleFor(x => x.Name, (f) => f.Name.FirstName(Gender.Male)).RuleFor(x => x.Activity, f => f.PickRandom(new string[] { "Login", "Logout", "Register", "CalledShop", "CalledCart", "CalledCheckout", "CalledFAQ", "MaliciousBehavior" }));

            return faker.Generate(logCount);
        }
    }
}