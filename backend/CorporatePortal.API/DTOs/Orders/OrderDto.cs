namespace CorporatePortal.API.DTOs.Orders
{
    public class OrderDto
    {
        public int Id { get; set; }
        public string OpCode { get; set; } = string.Empty;
        public string Number { get; set; } = string.Empty;
        public string Type { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public string ShipmentNumber { get; set; } = string.Empty;
        public string ShipmentDate { get; set; } = string.Empty;
        public string DesiredDate { get; set; } = string.Empty;
        public string PlannedDate { get; set; } = string.Empty;
        public string Creator { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; }
        public string Status { get; set; } = string.Empty;
        public string Salon { get; set; } = string.Empty;
        public string Designer { get; set; } = string.Empty;
        public string Warehouse { get; set; } = string.Empty;
        public string Production { get; set; } = string.Empty;
        public string Logistics { get; set; } = string.Empty;
        public string Payment { get; set; } = string.Empty;
        public string FilePath { get; set; } = string.Empty;
    }

    public class CreateOrderRequest
    {
        public string OpCode { get; set; } = string.Empty;
        public string Number { get; set; } = string.Empty;
        public string Type { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
    }

    public class UpdateOrderRequest
    {
        public string? OpCode { get; set; }
        public string? Number { get; set; }
        public string? Type { get; set; }
        public string? Description { get; set; }
        public string? ShipmentNumber { get; set; }
        public string? ShipmentDate { get; set; }
        public string? DesiredDate { get; set; }
        public string? PlannedDate { get; set; }
        public string? Status { get; set; }
        public string? Salon { get; set; }
        public string? Designer { get; set; }
        public string? Warehouse { get; set; }
        public string? Production { get; set; }
        public string? Logistics { get; set; }
        public string? Payment { get; set; }
    }
} 