using AutoMapper;
using CorporatePortal.Models;
using CorporatePortal.DTOs;
using CorporatePortal.Services;
using System.Text.Json;

namespace CorporatePortal.API;

public class MappingProfile : Profile
{
    public MappingProfile()
    {
        // User mappings
        CreateMap<User, UserDto>()
            .ForMember(dest => dest.Role, opt => opt.MapFrom(src => src.Role.ToString()));

        CreateMap<CreateUserDto, User>()
            .ForMember(dest => dest.PasswordHash, opt => opt.MapFrom(src => src.Password));

        CreateMap<UpdateUserDto, User>()
            .ForAllMembers(opts => opts.Condition((src, dest, srcMember) => srcMember != null));

        CreateMap<User, LoginResponseDto>()
            .ForMember(dest => dest.Role, opt => opt.MapFrom(src => src.Role.ToString()))
            .ForMember(dest => dest.Token, opt => opt.MapFrom(src => "sample-jwt-token"))
            .ForMember(dest => dest.ExpiresAt, opt => opt.MapFrom(src => DateTime.UtcNow.AddHours(24)));

        // Order mappings
        CreateMap<Order, OrderDto>()
            .ForMember(dest => dest.Status, opt => opt.MapFrom(src => src.Status.ToString()))
            .ForMember(dest => dest.Priority, opt => opt.MapFrom(src => src.Priority.ToString()))
            .ForMember(dest => dest.CreatedByName, opt => opt.MapFrom(src => $"{src.CreatedBy.FirstName} {src.CreatedBy.LastName}"))
            .ForMember(dest => dest.AssignedToName, opt => opt.MapFrom(src => src.AssignedTo != null ? $"{src.AssignedTo.FirstName} {src.AssignedTo.LastName}" : null));

        CreateMap<CreateOrderDto, Order>();

        CreateMap<UpdateOrderDto, Order>()
            .ForAllMembers(opts => opts.Condition((src, dest, srcMember) => srcMember != null));

        CreateMap<OrderItem, OrderItemDto>();

        CreateMap<CreateOrderItemDto, OrderItem>();

        CreateMap<OrderStatistics, OrderStatisticsDto>();

        CreateMap<OrderStatusCount, OrderStatusCountDto>();

        CreateMap<OrderPriorityCount, OrderPriorityCountDto>();

        // Document mappings
        CreateMap<Document, DocumentDto>()
            .ForMember(dest => dest.Status, opt => opt.MapFrom(src => src.Status.ToString()))
            .ForMember(dest => dest.CreatedByName, opt => opt.MapFrom(src => $"{src.CreatedBy.FirstName} {src.CreatedBy.LastName}"))
            .ForMember(dest => dest.UpdatedByName, opt => opt.MapFrom(src => src.UpdatedBy != null ? $"{src.UpdatedBy.FirstName} {src.UpdatedBy.LastName}" : null));

        CreateMap<CreateDocumentDto, Document>();

        CreateMap<UpdateDocumentDto, Document>()
            .ForAllMembers(opts => opts.Condition((src, dest, srcMember) => srcMember != null));

        // Chat mappings
        CreateMap<ChatMessage, ChatHistoryDto>()
            .ForMember(dest => dest.Sources, opt => opt.MapFrom(src => 
                !string.IsNullOrEmpty(src.Sources) ? JsonSerializer.Deserialize<List<ChatSourceDto>>(src.Sources) : new List<ChatSourceDto>()))
            .ForMember(dest => dest.UserName, opt => opt.MapFrom(src => src.User != null ? $"{src.User.FirstName} {src.User.LastName}" : null));

        CreateMap<ChatResponse, ChatResponseDto>()
            .ForMember(dest => dest.Sources, opt => opt.MapFrom(src => src.Sources.Select(s => new ChatSourceDto
            {
                Filename = s.Filename,
                Source = s.Source,
                Content = s.Content
            })));
    }
} 