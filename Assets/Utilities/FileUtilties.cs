using System;
using System.IO;

public static class FileUtilities
{
    //====================================================================================================
    //====================================================================================================

    /// <summary>
    /// Return File contents as byte array
    /// </summary>
    public static byte[] ReadFile(string path)
    {
        return File.ReadAllBytes(path);
    }

    /// <summary>
    /// Copy file from one path to another
    /// </summary>
    public static void CopyFile(string fromPath, string toPath)
    {
        File.Copy(fromPath, toPath);
    }

    /// <summary>
    /// delete file
    /// </summary>
    public static void DeleteFile(string path)
    {
        File.Delete(path);
    }

    //====================================================================================================
    //====================================================================================================

    /// <summary>
    /// Save a single file, create directory if non exist
    /// </summary>
    public static void CreateDirectoryAndSavefile(string path, byte[] data)
    {
        if (string.IsNullOrEmpty(path)) return;

        FileInfo file = new(path);
        file.Directory.Create();
        File.WriteAllBytes(path, data);
    }

    /// <summary>
    /// Save a single file, create directory if non exist
    /// </summary>
    public static void CreateDirectoryAndSavefiles(string directoryPath,params (string name, byte[] data)[] files)
    {
        if (string.IsNullOrEmpty(directoryPath)) return;

        Directory.CreateDirectory(directoryPath);

        foreach (var (name, data) in files)
        {
            if (string.IsNullOrEmpty(name)) continue;

            var filepath = Path.Combine(directoryPath, name);

            FileInfo fi = new(filepath);
            fi.Directory.Create();
            File.WriteAllBytes(filepath, data);
        }
    }



    //====================================================================================================
    //====================================================================================================

    static readonly string[] fileSizeSuffix = { "Bytes", "KB", "MB", "GB", "TB", "PB" };

    /// <summary>
    /// Returns formatted string from file byte size
    /// </summary>
    public static string FormatBytesSizeString(long bytes)
    {
        int counter = 0;
        decimal number = bytes;
        int sizeSlice = 1024;
        while (Math.Round(number / sizeSlice) >= 1)
        {
            number = number / sizeSlice;
            counter++;
        }
        return string.Format("{0:n1} {1}", number, fileSizeSuffix[counter]);
    }

    //====================================================================================================
    //====================================================================================================

    public static string GetUniqueFilePath_AppendNumber(string path)
    {
        if (!File.Exists(path)) return path;

        var directory = Path.GetDirectoryName(path);
        var fileName = Path.GetFileNameWithoutExtension(path);
        var extension = Path.GetExtension(path);

        int count = 0;
        string newPath;
        do
        {
            newPath = Path.Combine(directory, fileName + ++count + extension);
        }
        while (File.Exists(newPath));

        return newPath;
    }
}