from django.test import TestCase
from django.urls import reverse
from .models import Nota

class ArquitecturaTests(TestCase):
    def test_home_page_status_code(self):
        response = self.client.get(reverse("arquitectura:home"))
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, "Explorador Django")

    def test_flujo_page_status_code(self):
        response = self.client.get(reverse("arquitectura:flujo"))
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, "Flujo URL")

    def test_mvc_page_status_code_empty(self):
        response = self.client.get(reverse("arquitectura:mvc"))
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, "Aún no hay notas")

    def test_mvc_page_with_notes(self):
        Nota.objects.create(titulo="Test Nota", contenido="Contenido de prueba")
        response = self.client.get(reverse("arquitectura:mvc"))
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, "Test Nota")
        self.assertContains(response, "Contenido de prueba")

