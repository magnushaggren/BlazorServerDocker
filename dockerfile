FROM mcr.microsoft.com/dotnet/aspnet:7.0 as base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["BlazorServerDocker.csproj", "."]
RUN dotnet restore "BlazorServerDocker.csproj"
COPY . .
RUN dotnet build "BlazorServerDocker.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "BlazorServerDocker.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT [ "dotnet", "BlazorServerDocker.dll"]