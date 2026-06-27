using Microsoft.AspNetCore.Mvc;

namespace TechFix.Controllers;

[ApiController]
[Route("/user")]
public class UserController : ControllerBase
{
    [HttpGet]
    public IActionResult Get()
    {
        return Ok(new { Message = "UserController is working!" });
    }

    [HttpPost]
    public IActionResult Post([FromBody] User user)
    {
        // Here you would typically save the user to a database
        return CreatedAtAction(nameof(Get), new { id = user.Id }, user);
    }
}