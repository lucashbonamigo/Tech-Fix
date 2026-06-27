# Estágio 1: Base de Construção (Build)
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY *.csproj ./
RUN dotnet restore
COPY . ./
RUN dotnet build -c Release -o /app/build

FROM build AS test
# Roda os testes direto no código compilado do estágio anterior.
# Se algum teste falhar, o Docker cancela tudo e exibe o erro aqui.
RUN dotnet test --no-build -c Release

# Estágio 3: Publicação (Publish)
# Repare que ele só chega aqui se o estágio de 'test' passar sem erros.
FROM build AS publish
RUN dotnet publish -c Release -o /app/publish /p:UseAppHost=false

# Estágio 4: Ambiente de Execução Final (Runtime)
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .
USER app
EXPOSE 8080
ENTRYPOINT ["dotnet", "TechFixApi.dll"]