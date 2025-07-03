/*
 * About:
 * Provides a fast way to open Unity Related Directories
 * 
 */

#if UNITY_EDITOR

using UnityEngine;
using UnityEditor;
using System.IO;
using System.Diagnostics;

public class OpenFolders
{
    [MenuItem("EditorTools/Open Folder/Persistent data")]
    static void OpenPersistentData()
    {
        string path = Application.persistentDataPath;
        Process.Start(path);
    }

    [MenuItem("EditorTools/Open Folder/Streaming Assets")]
    private static void OpenStreamingAssets()
    {
        string path = Application.streamingAssetsPath;
        Process.Start(path);
    }

    [MenuItem("EditorTools/Open Folder/Console Log")]
    static void OpenConsoleLog()
    {
        string path = Application.consoleLogPath;
        Process.Start(path);
    }
    [MenuItem("EditorTools/Open Folder/Editor Log")]
    private static void OpenEditorLog()
    {
#if UNITY_EDITOR_OSX
			string rootFolderPath = System.Environment.GetFolderPath(System.Environment.SpecialFolder.Personal);
			string libraryPath = Path.Combine(rootFolderPath, "Library");
			string logsFolder = Path.Combine(libraryPath, "Logs");
			string path = Path.Combine(logsFolder, "Unity");
            Process.Start(path);
#elif UNITY_EDITOR_WIN
        string rootFolderPath = System.Environment.ExpandEnvironmentVariables("%localappdata%");
        string unityFolder = Path.Combine(rootFolderPath, "Unity");
        string path = Path.Combine(unityFolder, "Editor");
        Process.Start(path);
#endif
    }

    [MenuItem("EditorTools/Open Folder/Editor root")]
    static void OpenEditorRoot()
    {
        string path = Directory.GetParent(EditorApplication.applicationPath).ToString();
        Process.Start(path);
    }

    [MenuItem("EditorTools/Open Folder/Script Templates")]
    static void OpenScriptTemplate()
    {
        string path = Directory.GetParent(EditorApplication.applicationPath) + "/Data/Resources/ScriptTemplates/";
        Process.Start(path);
    }
}

#endif