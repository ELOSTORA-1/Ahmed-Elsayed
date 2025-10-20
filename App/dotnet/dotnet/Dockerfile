#Base-Image
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /source

#Copy Csproj And Restore Dependencies
#COPY *.csproj .
#RUN dotnet restore

#Copy and Publish App Files
COPY . .
#RUN dotnet publish -c release -o /app


#Run-time Image
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /source
COPY --from=build /source .

# Make Entrypoint
ENTRYPOINT [ "dotnet", "dotnet.dll" ]
