using Microsoft.EntityFrameworkCore;
using CorporatePortal.API.Models;

namespace CorporatePortal.API.Data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {
        }

        public DbSet<User> Users { get; set; }
        public DbSet<Document> Documents { get; set; }
        public DbSet<Order> Orders { get; set; }
        public DbSet<DocumentCategory> DocumentCategories { get; set; }
        public DbSet<ChatMessage> ChatMessages { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // User configuration
            modelBuilder.Entity<User>(entity =>
            {
                entity.HasIndex(e => e.Email).IsUnique();
                entity.HasIndex(e => e.Nickname).IsUnique();
            });

            // Document configuration
            modelBuilder.Entity<Document>(entity =>
            {
                entity.HasIndex(e => e.AddedDate);
                entity.HasIndex(e => e.Category);
            });

            // Order configuration
            modelBuilder.Entity<Order>(entity =>
            {
                entity.HasIndex(e => e.OpCode);
                entity.HasIndex(e => e.Number);
                entity.HasIndex(e => e.Status);
                entity.HasIndex(e => e.CreatedAt);
            });

            // ChatMessage configuration
            modelBuilder.Entity<ChatMessage>(entity =>
            {
                entity.HasIndex(e => e.CreatedAt);
            });

            // Seed data
            SeedData(modelBuilder);
        }

        private void SeedData(ModelBuilder modelBuilder)
        {
            // Admin user
            modelBuilder.Entity<User>().HasData(new User
            {
                Id = 1,
                Nickname = "admin",
                Email = "admin@corporate.com",
                PasswordHash = BCrypt.Net.BCrypt.HashPassword("admin123"),
                Role = "Admin",
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            });

            // Employee user
            modelBuilder.Entity<User>().HasData(new User
            {
                Id = 2,
                Nickname = "employee",
                Email = "employee@corporate.com",
                PasswordHash = BCrypt.Net.BCrypt.HashPassword("employee123"),
                Role = "Employee",
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            });

            // Document categories
            modelBuilder.Entity<DocumentCategory>().HasData(
                new DocumentCategory { Id = 1, Name = "Общие документы", Description = "Общая документация компании" },
                new DocumentCategory { Id = 2, Name = "Рекламные материалы", Description = "Рекламные материалы и презентации" },
                new DocumentCategory { Id = 3, Name = "Прайсы", Description = "Прайс-листы и цены" }
            );

            // Sample orders
            modelBuilder.Entity<Order>().HasData(new Order
            {
                Id = 1,
                OpCode = "ОфГр",
                Number = "105",
                Type = "Рекламация",
                Description = "Прислали горизонтальные...",
                ShipmentNumber = "2943",
                ShipmentDate = "06.06.2024",
                DesiredDate = "06.06.2024",
                PlannedDate = "06.06.2024",
                Creator = "Vladimir2018",
                CreatedAt = DateTime.Parse("2024-05-21T13:27:00"),
                Status = "В план на отгрузку",
                Salon = "...",
                Designer = "...",
                Warehouse = "Обработка заказа произведена",
                Production = "В производстве",
                Logistics = "...",
                Payment = "Не сверено",
                FilePath = "",
                UserId = 2
            });
        }
    }
} 