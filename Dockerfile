FROM mcr.microsoft.com/dotnet/sdk:7.0 as builder

COPY . /src
WORKDIR "/src"  

  
RUN  dotnet build "HelloWorldApp.sln" && dotnet test "HelloWorldApp.sln"  && dotnet publish "HelloWorldApp/HelloWorldApp.csproj" -c Release -o /src/out
     #&& dotnet publish "HelloWorldApp/HelloWorldApp.csproj"
  
# Build runtime image  
FROM mcr.microsoft.com/dotnet/aspnet:7.0 as prod
WORKDIR /src  
COPY --from=builder /src/out .  
ENTRYPOINT ["dotnet", "HelloWorldApp.dll"]