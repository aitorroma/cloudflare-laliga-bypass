import requests
import time
import configparser
import os

# Leer configuración
config = configparser.ConfigParser()
config_path = os.path.join(os.path.dirname(__file__), 'config.ini')
config.read(config_path)

# Configuración
webhook_url = config['settings']['webhook_url']
domain_to_report = config['settings']['domain_to_report']
domain_to_check = "check.aitorroma.com"  # Dominio fijo para verificar Cloudflare

def check_domain_cloudflare(domain):
    try:
        response = requests.get(f"https://{domain}", timeout=10)
        return "Cloudflare está activo en este sitio web" in response.text
    except requests.RequestException:
        return False

def send_webhook(domain, accessible):
    payload = {
        "domain": domain,
        "accessible": accessible
    }
    try:
        response = requests.post(webhook_url, json=payload)
        if response.status_code == 200:
            print(f"Webhook enviado para {domain} con accesibilidad {accessible}")
        else:
            print(f"Error al enviar el webhook para {domain}: {response.status_code}")
    except requests.RequestException as e:
        print(f"Error al enviar el webhook: {str(e)}")

def check_and_send():
    while True:
        # Verificar si el dominio tiene Cloudflare activo
        is_cloudflare_active = check_domain_cloudflare(domain_to_check)

        # Enviar webhook con el estado
        send_webhook(domain_to_report, is_cloudflare_active)

        # Esperar 3 minutos antes de la siguiente verificación
        time.sleep(180)

if __name__ == "__main__":
    print(f"Iniciando monitoreo de Cloudflare para {domain_to_check}")
    check_and_send()
