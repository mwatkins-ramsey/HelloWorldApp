FROM 058238361356.dkr.ecr.us-east-1.amazonaws.com/innersource/dotnet/rs-dotnet70:IR.1.0.0-builder-2023-06-30-T19.36.13 as build
ARG VSS_NUGET_TOKEN
ENV VSS_NUGET_EXTERNAL_FEED_ENDPOINTS {\"endpointCredentials\":[{\"endpoint\":\"https://pkgs.dev.azure.com/RamseySolutions/_packaging/RamseySolutions/nuget/v3/index.json\",\"username\":\"ArtifactsDocker\",\"password\":\"${VSS_NUGET_TOKEN}\"}]}

COPY . /src
WORKDIR "/src"  

  
RUN  dotnet build "HelloWorldApp.sln" -c Release --no-restore \
  && dotnet test "HelloWorldApp.sln" -c Release --no-build \
  && dotnet publish "HelloWorldApp/HelloWorldApp.csproj" --no-build -c Release -o /publish/service 
  
# Build runtime image  
FROM 058238361356.dkr.ecr.us-east-1.amazonaws.com/innersource/dotnet/rs-dotnet70:IR.1.0.0-2023-06-30-T19.36.27 as prod
WORKDIR /app  
COPY --from=build-env /app/out .  
ENTRYPOINT ["dotnet", "aspnetapp.dll"]