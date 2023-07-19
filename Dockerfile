FROM mcr.microsoft.com/dotnet/sdk:7.0 as builder

COPY . /src
WORKDIR "/src"  
ARG CACHEBUST=1
RUN  dotnet restore "HelloWorldApp.sln" &&  \
     dotnet build "HelloWorldApp.sln" &&  \
     dotnet test "HelloWorldApp.sln"  &&  \
     dotnet publish "HelloWorldApp/HelloWorldApp.csproj" -c Release -o /src/out
     #&& dotnet publish "HelloWorldApp/HelloWorldApp.csproj"
  
# Build runtime image  
FROM mcr.microsoft.com/dotnet/aspnet:7.0 as prod
ENV API_PORT=5000
WORKDIR /src  
COPY --from=builder /src/out .  
ENTRYPOINT ["dotnet", "HelloWorldApp.dll"]