using SettingsMenu.Clase;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Text.Json;

namespace SettingsMenu.Controlador
{
    internal class ControladorArchivos
    {

        public static void guardarJSON()
        {
            try
            {
                // Obtener la ruta de datos del usuario de Godot
                string rutaDirectorio = ObtenerRutaDatosUsuarioGodot();

                // Crear la ruta completa del archivo JSON en la subcarpeta Proyecto Escalera
                string rutaProyecto = Path.Combine(rutaDirectorio, "Proyecto Escalera");
                string rutaArchivo = Path.Combine(rutaProyecto, "ajustes.json");

                // Crear el directorio si no existe
                if (!Directory.Exists(rutaProyecto))
                {
                    Directory.CreateDirectory(rutaProyecto);
                }

                // Serializar la lista de ajustes a formato JSON
                string jsonString = JsonSerializer.Serialize(Clase.Ajustes.listaAjustes);

                // Guardar el JSON en el archivo especificado
                File.WriteAllText(rutaArchivo, jsonString);

                Console.WriteLine("Los ajustes se han guardado correctamente en formato JSON.");
            }
            catch (Exception e)
            {
                Console.WriteLine("Error al guardar los ajustes: " + e.Message);
            }
        }

        private static string ObtenerRutaDatosUsuarioGodot()
        {
            // Obtener la ruta del directorio de datos del usuario (AppData\Roaming)
            string appDataPath = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData);

            // Combinar la ruta con el subdirectorio de Godot
            string godotUserDataPath = Path.Combine(appDataPath, "Godot", "app_userdata");

            return godotUserDataPath;
        }
    }
}
