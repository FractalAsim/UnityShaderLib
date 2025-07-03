/*
 * About:
 * Provides a window that gives information about the current code base in the unity project
 * 
 * Sources:
 * https://github.com/Geri-Borbas/Unity.Library.eppz
 * 
 */

#if UNITY_EDITOR

using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEditor;
using UnityEngine;

public class CodeInfoWindow : EditorWindow
{
    StringBuilder log;
    Vector2 scrollPosition;
    
    [MenuItem("EditorTools/Code Info")]
    public static void ShowWindow()
    {
        var windowName = "Code Info";
        var window = GetWindow<CodeInfoWindow>(windowName);

        window.Show();
        window.Focus();
        window.CalculateStatistics();
    }

    void OnGUI()
    {
        if (GUILayout.Button("Recalculate"))
        {
            CalculateStatistics();
        }
        scrollPosition = EditorGUILayout.BeginScrollView(scrollPosition);
        EditorGUILayout.HelpBox(log.ToString(), MessageType.None);
        EditorGUILayout.EndScrollView();
    }

    void CalculateStatistics()
    {
        string folderPath = System.IO.Directory.GetCurrentDirectory();
        folderPath += @"/Assets";

        // Per file statistics.
        List<FileStats> codeStat = CodeStatsForFolder(folderPath);

        // Overall.
        int totalLineCount = 0;
        int totalStatementCount = 0;
        foreach (FileStats eachFileStat in codeStat)
        {
            totalLineCount += eachFileStat.LineCount;
            totalStatementCount += eachFileStat.StatementCount;
        }
        int averageLineCount = totalLineCount / codeStat.Count;
        int averageStatementCount = totalStatementCount / codeStat.Count;

        // Create new string.
        log = new StringBuilder();
        log.Append("File count: " + codeStat.Count + "\n");
        log.Append("Line count: " + totalLineCount + "\n");
        log.Append("Statement count: " + totalStatementCount + "\n");
        log.Append("Average line count: " + averageLineCount + "\n");
        log.Append("Average statement count: " + averageStatementCount + "\n");

        int barLength = 50;

        // Order by statement count.
        List<FileStats> statementCountSortedCodeStat = codeStat.OrderBy(fileStat => fileStat.StatementCount).ToList();
        int maximumStatementCount = statementCountSortedCodeStat.Last().StatementCount;

        // Log per file statistics.
        foreach (FileStats eachFileStat in statementCountSortedCodeStat)
        {
            // A bar representing line count.
            int displayValue = Mathf.FloorToInt(((float)eachFileStat.StatementCount / (float)maximumStatementCount) * (float)barLength);
            string bar = "";
            for (int i = 0; i < barLength; i++)
            { 
                bar += (i < displayValue) ? "█" : "░"; 
            }

            log.Append(bar + " " + eachFileStat.Name.Replace(folderPath, "") + ": " + eachFileStat.StatementCount + " (" + eachFileStat.LineCount + ")\n");
        }
    }

    static List<FileStats> CodeStatsForFolder(string folderPath)
    {
        List<FileStats> codeStat = new List<FileStats>();

        string[] fileNames = System.IO.Directory.GetFiles(folderPath, "*.cs");
        foreach (string eachFileName in fileNames)
        { 
            codeStat.Add(FileStatForFile(eachFileName)); 
        }

        // Collect from subfolders.
        string[] folders = System.IO.Directory.GetDirectories(folderPath);
        foreach (string eachFolder in folders)
        { 
            codeStat.AddRange(CodeStatsForFolder(eachFolder)); 
        }

        return codeStat;
    }

    static FileStats FileStatForFile(string fileName)
    {
        FileStats fileStats = new FileStats(fileName);
        System.IO.StreamReader reader = System.IO.File.OpenText(fileName);
        while (reader.Peek() >= 0)
        { 
            fileStats.ProcessLine(reader.ReadLine()); 
        }
        reader.Close();
        return fileStats;
    }
}

class FileStats
{
    public string Name;
    public int LineCount;
    public int StatementCount;
    public int UsingStatementCount;
    public int IfStatementCount;
    public FileStats(string name)
    {
        Name = name;
    }
    public void ProcessLine(string line)
    {
        LineCount++;

        var containsStatement = line.Contains(";") || line.Contains("}");
        if (containsStatement) StatementCount++;

        var containsUsingStatement = line.Contains("using");
        if (containsUsingStatement) UsingStatementCount++;

        var containsIfStatement = line.Contains("if");
        if (containsIfStatement) IfStatementCount++;
    }
}

#endif