#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["jenkins_test.csproj", "."]
RUN dotnet restore "./jenkins_test.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "jenkins_test.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "jenkins_test.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "jenkins_test.dll"]