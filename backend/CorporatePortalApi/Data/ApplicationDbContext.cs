using Microsoft.EntityFrameworkCore;
using CorporatePortalApi.Models;

namespace CorporatePortalApi.Data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }

        public DbSet<User> Users { get; set; }
        public DbSet<InfoItem> InfoItems { get; set; }
        public DbSet<Order> Orders { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Конфигурация User
            modelBuilder.Entity<User>(entity =>
            {
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Email).HasMaxLength(100).IsRequired();
                entity.Property(e => e.Nick).HasMaxLength(50).IsRequired();
                entity.Property(e => e.Password).HasMaxLength(100).IsRequired();
                entity.HasIndex(e => e.Email).IsUnique();
                entity.HasIndex(e => e.Nick).IsUnique();
            });

            // Конфигурация InfoItem
            modelBuilder.Entity<InfoItem>(entity =>
            {
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Title).HasMaxLength(200).IsRequired();
                entity.Property(e => e.Description).HasMaxLength(1000).IsRequired();
                entity.Property(e => e.Category).HasMaxLength(50).IsRequired();
                entity.Property(e => e.FilePath).HasMaxLength(500);
                entity.Property(e => e.FileType).HasMaxLength(100);
            });

            // Конфигурация Order
            modelBuilder.Entity<Order>(entity =>
            {
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Title).HasMaxLength(200).IsRequired();
                entity.Property(e => e.Description).HasMaxLength(1000).IsRequired();
                entity.Property(e => e.Notes).HasMaxLength(500);
                entity.Property(e => e.Priority).HasMaxLength(100);
                entity.Property(e => e.TotalAmount).HasPrecision(18, 2);
                
                // Связь с User
                entity.HasOne(e => e.AssignedUser)
                    .WithMany()
                    .HasForeignKey(e => e.AssignedUserId)
                    .OnDelete(DeleteBehavior.SetNull);
            });

            // Seed данные
            SeedData(modelBuilder);
        }

        private void SeedData(ModelBuilder modelBuilder)
        {
            // Seed Users
            modelBuilder.Entity<User>().HasData(
                new User
                {
                    Id = 1,
                    Nick = "admin",
                    Email = "admin@company.com",
                    Password = "admin123", // В реальном проекте хешировать!
                    CreatedAt = DateTime.UtcNow,
                    IsActive = true
                },
                new User
                {
                    Id = 2,
                    Nick = "employee",
                    Email = "employee@company.com",
                    Password = "employee123",
                    CreatedAt = DateTime.UtcNow,
                    IsActive = true
                }
            );

            // Seed InfoItems
            modelBuilder.Entity<InfoItem>().HasData(
                new InfoItem
                {
                    Id = 1,
                    Title = "Правила внутреннего трудового распорядка",
                    Description = "Документ, регламентирующий порядок работы сотрудников",
                    Category = "GeneralDocuments",
                    CreatedAt = DateTime.UtcNow,
                    IsActive = true
                },
                new InfoItem
                {
                    Id = 2,
                    Title = "Политика безопасности",
                    Description = "Документ о мерах безопасности на предприятии",
                    Category = "GeneralDocuments",
                    CreatedAt = DateTime.UtcNow,
                    IsActive = true
                },
                new InfoItem
                {
                    Id = 3,
                    Title = "Баннер для сайта",
                    Description = "Рекламный баннер для корпоративного сайта",
                    Category = "AdvertisingMaterials",
                    CreatedAt = DateTime.UtcNow,
                    IsActive = true
                },
                new InfoItem
                {
                    Id = 4,
                    Title = "Прайс-лист на услуги",
                    Description = "Актуальный прайс-лист на все услуги компании",
                    Category = "Prices",
                    CreatedAt = DateTime.UtcNow,
                    IsActive = true
                }
            );

            // Seed Orders
            modelBuilder.Entity<Order>().HasData(
                new Order
                {
                    Id = 1,
                    Title = "Заказ на разработку сайта",
                    Description = "Создание корпоративного сайта для клиента",
                    Status = OrderStatus.InProgress,
                    CreatedAt = DateTime.UtcNow.AddDays(-5),
                    AssignedUserId = 2,
                    Priority = "High",
                    TotalAmount = 50000
                },
                new Order
                {
                    Id = 2,
                    Title = "Заказ на дизайн логотипа",
                    Description = "Разработка логотипа для новой компании",
                    Status = OrderStatus.New,
                    CreatedAt = DateTime.UtcNow.AddDays(-2),
                    Priority = "Medium",
                    TotalAmount = 15000
                },
                new Order
                {
                    Id = 3,
                    Title = "Заказ на печать рекламных материалов",
                    Description = "Печать буклетов и листовок",
                    Status = OrderStatus.Completed,
                    CreatedAt = DateTime.UtcNow.AddDays(-10),
                    CompletedAt = DateTime.UtcNow.AddDays(-1),
                    AssignedUserId = 2,
                    Priority = "Low",
                    TotalAmount = 8000
                }
            );
        }
    }
} 