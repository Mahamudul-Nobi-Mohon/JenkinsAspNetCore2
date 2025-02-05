# Use the official .NET image as a base image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

# Use the official SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["JenkinsAspNetCore2/JenkinsAspNetCore2.csproj", "JenkinsAspNetCore2/"]
RUN dotnet restore "JenkinsAspNetCore2/JenkinsAspNetCore2.csproj"
COPY . .
WORKDIR "/src/JenkinsAspNetCore2"
RUN dotnet build "JenkinsAspNetCore2.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "JenkinsAspNetCore2.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "JenkinsAspNetCore2.dll"]
