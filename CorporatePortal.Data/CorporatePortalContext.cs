using Microsoft.EntityFrameworkCore;
using CorporatePortal.Models;
using BCrypt.Net;

namespace CorporatePortal.Data
{
    public class CorporatePortalContext : DbContext
    {
        public CorporatePortalContext(DbContextOptions<CorporatePortalContext> options)
            : base(options)
        {
        }

        public DbSet<User> Users { get; set; }
        public DbSet<Order> Orders { get; set; }
        public DbSet<OrderItem> OrderItems { get; set; }
        public DbSet<Document> Documents { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // User configuration
            modelBuilder.Entity<User>(entity =>
            {
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Username).IsRequired().HasMaxLength(50);
                entity.Property(e => e.Email).IsRequired().HasMaxLength(100);
                entity.Property(e => e.PasswordHash).IsRequired();
                entity.Property(e => e.Role).IsRequired();

                entity.HasIndex(e => e.Username).IsUnique();
                entity.HasIndex(e => e.Email).IsUnique();
            });

            // Order configuration
            modelBuilder.Entity<Order>(entity =>
            {
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Title).IsRequired().HasMaxLength(200);
                entity.Property(e => e.Description).HasMaxLength(1000);
                entity.Property(e => e.Status).IsRequired();
                entity.Property(e => e.Priority).IsRequired();
                entity.Property(e => e.CreatedAt).IsRequired();
                entity.Property(e => e.UpdatedAt).IsRequired();

                entity.HasOne(e => e.CreatedBy)
                    .WithMany()
                    .HasForeignKey(e => e.CreatedById)
                    .OnDelete(DeleteBehavior.Restrict);

                entity.HasOne(e => e.AssignedTo)
                    .WithMany()
                    .HasForeignKey(e => e.AssignedToId)
                    .OnDelete(DeleteBehavior.Restrict);
            });

            // OrderItem configuration
            modelBuilder.Entity<OrderItem>(entity =>
            {
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Name).IsRequired().HasMaxLength(200);
                entity.Property(e => e.Description).HasMaxLength(500);
                entity.Property(e => e.Quantity).IsRequired();
                entity.Property(e => e.UnitPrice).IsRequired();

                entity.HasOne(e => e.Order)
                    .WithMany(o => o.Items)
                    .HasForeignKey(e => e.OrderId)
                    .OnDelete(DeleteBehavior.Cascade);
            });

            // Document configuration
            modelBuilder.Entity<Document>(entity =>
            {
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Title).IsRequired().HasMaxLength(200);
                entity.Property(e => e.Category).IsRequired().HasMaxLength(100);
                entity.Property(e => e.FilePath).HasMaxLength(500);
                entity.Property(e => e.Status).IsRequired();
                entity.Property(e => e.CreatedAt).IsRequired();
                entity.Property(e => e.UpdatedAt).IsRequired();

                entity.HasOne(e => e.CreatedBy)
                    .WithMany()
                    .HasForeignKey(e => e.CreatedById)
                    .OnDelete(DeleteBehavior.Restrict);
            });

            // Seed data
            SeedData(modelBuilder);
        }

        private void SeedData(ModelBuilder modelBuilder)
        {
            // Admin user
            var adminUser = new User
            {
                Id = 1,
                Username = "admin",
                Email = "admin@corporate.com",
                PasswordHash = BCrypt.Net.BCrypt.HashPassword("admin123"),
                Role = UserRole.Admin,
                CreatedAt = DateTime.UtcNow
            };

            // Employee user
            var employeeUser = new User
            {
                Id = 2,
                Username = "employee",
                Email = "employee@corporate.com",
                PasswordHash = BCrypt.Net.BCrypt.HashPassword("employee123"),
                Role = UserRole.Employee,
                CreatedAt = DateTime.UtcNow
            };

            // Documents
            var document1 = new Document
            {
                Id = 1,
                Title = "Политика безопасности",
                Category = "Общие документы",
                Status = DocumentStatus.Published,
                CreatedById = 1,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };

            var document2 = new Document
            {
                Id = 2,
                Title = "Рекламный буклет 2024",
                Category = "Рекламные материалы",
                Status = DocumentStatus.Published,
                CreatedById = 1,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };

            // Orders
            var order1 = new Order
            {
                Id = 1,
                Title = "Заказ канцелярских товаров",
                Description = "Закупка канцелярских товаров для офиса",
                Status = OrderStatus.InProgress,
                Priority = OrderPriority.Normal,
                CreatedById = 2,
                AssignedToId = 1,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };

            var order2 = new Order
            {
                Id = 2,
                Title = "Обновление программного обеспечения",
                Description = "Обновление лицензий и ПО для всех компьютеров",
                Status = OrderStatus.New,
                Priority = OrderPriority.High,
                CreatedById = 1,
                AssignedToId = 2,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };

            modelBuilder.Entity<User>().HasData(adminUser, employeeUser);
            modelBuilder.Entity<Document>().HasData(document1, document2);
            modelBuilder.Entity<Order>().HasData(order1, order2);
        }
    }
} 