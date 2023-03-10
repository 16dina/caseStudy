# Get base SDK Image from MS
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS CS-build
WORKDIR /app

# Copy the CSPROJ file which is caseStudy.csproj and restore any dependecies (via NUGET package manager)
COPY *.csproj ./
RUN dotnet restore

# Copy all our project's files and build our release
COPY . ./
RUN dotnet publish -c Release -o out

# Generate the runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /app
EXPOSE 80
COPY --from=CS-build /app/out .
ENTRYPOINT ["dotnet", "caseStudy.dll"]