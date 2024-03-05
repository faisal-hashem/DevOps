import pulumi
import pulumi_azuread as azad

app = azad.Application("testingfh", display_name="testingfh")
sp = azad.ServicePrincipal("testingfh-sp", client_id=app.client_id)

pulumi.export('client_id', app.client_id)
pulumi.export('service_principal_password', sp.id)
