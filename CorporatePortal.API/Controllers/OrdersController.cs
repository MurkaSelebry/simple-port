using Microsoft.AspNetCore.Mvc;
using CorporatePortal.Services;
using CorporatePortal.DTOs;
using AutoMapper;

namespace CorporatePortal.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class OrdersController : ControllerBase
{
    private readonly IOrderService _orderService;
    private readonly IMapper _mapper;
    private readonly ILogger<OrdersController> _logger;

    public OrdersController(IOrderService orderService, IMapper mapper, ILogger<OrdersController> logger)
    {
        _orderService = orderService;
        _mapper = mapper;
        _logger = logger;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<OrderDto>>> GetOrders()
    {
        try
        {
            var orders = await _orderService.GetAllOrdersAsync();
            var orderDtos = _mapper.Map<IEnumerable<OrderDto>>(orders);
            return Ok(orderDtos);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting orders");
            return StatusCode(500, new { message = "Internal server error" });
        }
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<OrderDto>> GetOrder(int id)
    {
        try
        {
            var order = await _orderService.GetOrderByIdAsync(id);
            if (order == null)
            {
                return NotFound();
            }

            var orderDto = _mapper.Map<OrderDto>(order);
            return Ok(orderDto);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting order {OrderId}", id);
            return StatusCode(500, new { message = "Internal server error" });
        }
    }

    [HttpPost]
    public async Task<ActionResult<OrderDto>> CreateOrder([FromBody] CreateOrderDto request)
    {
        try
        {
            var order = _mapper.Map<Models.Order>(request);
            var createdOrder = await _orderService.CreateOrderAsync(order);
            var orderDto = _mapper.Map<OrderDto>(createdOrder);
            return CreatedAtAction(nameof(GetOrder), new { id = orderDto.Id }, orderDto);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error creating order");
            return StatusCode(500, new { message = "Internal server error" });
        }
    }

    [HttpPut("{id}")]
    public async Task<ActionResult<OrderDto>> UpdateOrder(int id, [FromBody] UpdateOrderDto request)
    {
        try
        {
            var order = _mapper.Map<Models.Order>(request);
            order.Id = id;
            var updatedOrder = await _orderService.UpdateOrderAsync(order);
            if (updatedOrder == null)
            {
                return NotFound();
            }

            var orderDto = _mapper.Map<OrderDto>(updatedOrder);
            return Ok(orderDto);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error updating order {OrderId}", id);
            return StatusCode(500, new { message = "Internal server error" });
        }
    }

    [HttpDelete("{id}")]
    public async Task<ActionResult> DeleteOrder(int id)
    {
        try
        {
            var result = await _orderService.DeleteOrderAsync(id);
            if (!result)
            {
                return NotFound();
            }

            return NoContent();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error deleting order {OrderId}", id);
            return StatusCode(500, new { message = "Internal server error" });
        }
    }

    [HttpGet("statistics")]
    public async Task<ActionResult<OrderStatisticsDto>> GetOrderStatistics()
    {
        try
        {
            var statistics = await _orderService.GetOrderStatisticsAsync();
            var statisticsDto = _mapper.Map<OrderStatisticsDto>(statistics);
            return Ok(statisticsDto);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting order statistics");
            return StatusCode(500, new { message = "Internal server error" });
        }
    }
} 