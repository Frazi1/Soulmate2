using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace Soulmate2_Server.Controllers
{
    public record AuthenticationRequest(string Username, string Password);

    [ApiController]
    [Route("/api/[controller]/[action]")]
    public class AuthController : ControllerBase
    {
        private readonly ILogger<AuthController> _logger;

        public AuthController(ILogger<AuthController> logger)
        {
            _logger = logger;
        }

        [HttpPost]
        public ActionResult Login([FromBody] AuthenticationRequest authenticationRequest)
        {
            _logger.LogInformation("Got request {userName}", authenticationRequest.Username);

            if (authenticationRequest is ("dmitry", "vychikov"))
            {
                return Ok();
            }

            return Unauthorized();
        }
    }
}