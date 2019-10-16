#Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
#For more information, please see https://aka.ms/containercompat

FROM microsoft/dotnet:2.1-aspnetcore-runtime-nanoserver-1803 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM microsoft/dotnet:2.1-sdk-nanoserver-1803 AS build
WORKDIR /src
COPY ["demo_App_Aks/demo_App_Aks.csproj", "demo_App_Aks/"]
RUN dotnet restore "demo_App_Aks/demo_App_Aks.csproj"
COPY . .
WORKDIR "/src/demo_App_Aks"
RUN dotnet build "demo_App_Aks.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "demo_App_Aks.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "demo_App_Aks.dll"]