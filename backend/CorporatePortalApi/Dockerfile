FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 6000
EXPOSE 6001

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY ["CorporatePortalApi/CorporatePortalApi.csproj", "CorporatePortalApi/"]
RUN dotnet restore "CorporatePortalApi/CorporatePortalApi.csproj"
COPY . .
WORKDIR "/src/CorporatePortalApi"
RUN dotnet build "CorporatePortalApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "CorporatePortalApi.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CorporatePortalApi.dll"] 