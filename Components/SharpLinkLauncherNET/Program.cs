﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using System.Drawing;
using System.Diagnostics;
using System.IO;
using System.Timers;

using SharpLinkLauncherNET.Interop;

namespace SharpLinkLauncherNET
{
	class Program
	{
		static void Main(string[] args)
		{
			if (args.Length != 3)
				// The number of arguments is not 2 (-l and -t) so exit.
				Environment.Exit((int)ExitCode.InvalidNumberArguments);

			string linkPath = null;
			int timeout = -1;
			bool elevate = false;

			foreach (string arg in args)
			{
				if (arg.ToLower().StartsWith("-l:"))
				{
					// Everything after -l: is the path, trim any surrounding quotes.
					string l = arg.Substring(3).Trim('\"');

					if (l == String.Empty)
						// If there was nothing after the -l: switch then exit.
						Environment.Exit((int)ExitCode.InvalidLinkPath);

					linkPath = l;
				}
				else if (arg.ToLower().StartsWith("-t:"))
				{
					// Everthing after -t: is the timeout, trim any surrounding quotes.
					string t = arg.Substring(3).Trim('\"');

					if (t == String.Empty)
						// If there was nothing after the -t: switch then exit.
						Environment.Exit((int)ExitCode.InvalidTimeout);

					timeout = int.Parse(t);
				}
				else if (arg.ToLower().StartsWith("-e:"))
				{
					string e = arg.Substring(3).Trim('\"');

					if (e == String.Empty)
						// If there was nothing after the -e: switch then exit.
						Environment.Exit((int)ExitCode.InvalidElevate);

					elevate = bool.Parse(e);
				}
			}

			if (String.IsNullOrEmpty(linkPath))
				// The path to the link does not exists so do nothing.
				Environment.Exit((int)ExitCode.InvalidLinkPath);

			// Valid values for the Timer.Interval is > 0.
			// We use -1 to indicate we should not wait for a WM_SHARPELINKLAUNCH message.
			if (timeout < -1 || timeout == 0)
				// The timeout was invalid so do nothing.
				Environment.Exit((int)ExitCode.InvalidTimeout);

			if (timeout == -1)
				// We are not waiting so execute the link and exit.
				StartProcessAndExit(linkPath, elevate);

			// Setup the timeout timer so we don't wait forever for the WM_SHARPELINKLAUNCH message.
			Timer timer = new Timer(timeout);
			timer.Elapsed += new ElapsedEventHandler(
				delegate
				{
					timer.Enabled = false;
			    	Environment.Exit((int)ExitCode.Timeout);
				});
			timer.Enabled = true;

            MSG lpMsg;

			// Loop through message until a quit message is received
            while (GetMessage(out lpMsg, IntPtr.Zero, 0, 0) == true)
            {
				if (lpMsg.message == WM_SHARPELINKLAUNCH)
				{
					// Disable the timer as we have received the WM_SHARPELINKLAUNCH message
					// and so that we don't kill the process prematurely.
					timer.Enabled = false;

					StartProcessAndExit(linkPath, elevate);
				}

                if (lpMsg.message == WM_ENDSESSION ||
					lpMsg.message == WM_CLOSE ||
					lpMsg.message == WM_QUIT)
                {
                    Environment.Exit((int)ExitCode.QuitMessage);
                }
            }
		}

		/// <summary>
		/// Execute the link and exit the process whether or not the execution is successful or not.
		/// </summary>
		/// <param name="linkPath">The link to be executed using ShellExecute.</param>
		/// <param name="elevate">Whether or not to execute the link with elevate privileges.</param>
		static void StartProcessAndExit(string linkPath, bool elevate)
		{
			if (elevate)
				RestartElevated(linkPath);

			try
			{
				ProcessStartInfo psi = new ProcessStartInfo(linkPath);
				psi.UseShellExecute = true;

				// Execute the link using ShellExecute and elevated if necessary.
				Process.Start(psi);
				Environment.Exit((int)ExitCode.Success);
			}
			catch
			{
				// If for some reason there was an exception executing the link squash it.
				Environment.Exit((int)ExitCode.ProcessStartFailed);
			}
		}

		/// <summary>
		/// Restart the link launcher elevated and exit the process whether or not the execution is successful or not.
		/// </summary>
		/// <param name="linkPath">The link to be executed using ShellExecute.</param>
		static void RestartElevated(string linkPath)
		{
			try
			{
				ProcessStartInfo psi = new ProcessStartInfo(System.Windows.Forms.Application.ExecutablePath);
				psi.UseShellExecute = true;
				psi.Verb = "runas";
				// Pass -1 to disable the timeout, the link to be launched
				// and false to not elevate as the process will already be elevated.
				psi.Arguments = String.Format("-t:{0} -l:\"{1}\" -e:{2}", -1, linkPath, false);
				Process p = Process.Start(psi);
				Environment.Exit((int)ExitCode.Success);
			}
			catch
			{
				// If for some reason there was an exception executing the link squash it.
				Environment.Exit((int)ExitCode.ProcessStartFailed);
			}
		}

		const int WM_SHARPELINKLAUNCH = 0x8000 + 540;

		#region WinAPI

		/// <summary>
		/// The GetMessage function retrieves a message from the calling thread's message queue.
		/// The function dispatches incoming sent messages until a posted message is available for retrieval.
		/// </summary>
		/// <param name="lpMsg">Points to an MSG structure that receives message information from the thread's message queue.</param>
		/// <param name="hWnd">
		/// Handle to the window whose messages are to be retrieved. The window must belong to the current thread.
		///		If hWnd is NULL, GetMessage retrieves messages for any window that belongs to the current thread,
		///		and any messages on the current thread's message queue whose hwnd value is NULL (see the MSG structure).
		///		Therefore if hWnd is NULL, both window messages and thread messages are processed.
		///		
		///		If hWnd is -1, GetMessage retrieves only messages on the current thread's message queue whose hwnd value is NULL,
		///		that is, thread messages as posted by PostMessage (when the hWnd parameter is NULL) or PostThreadMessage.
		///	</param>
		/// <param name="wMsgFilterMin">
		/// Specifies the integer value of the lowest message value to be retrieved.
		/// Use WM_KEYFIRST to specify the first keyboard message or WM_MOUSEFIRST to specify the first mouse message.
		///		Windows XP: Use WM_INPUT here and in wMsgFilterMax to specify only the WM_INPUT messages.
		///		If wMsgFilterMin and wMsgFilterMax are both zero, GetMessage returns all available messages (that is, no range filtering is performed). 
		/// </param>
		/// <param name="wMsgFilterMax">
		/// Specifies the integer value of the highest message value to be retrieved.
		/// Use WM_KEYLAST to specify the last keyboard message or WM_MOUSELAST to specify the last mouse message.
		///		Windows XP: Use WM_INPUT here and in wMsgFilterMin to specify only the WM_INPUT messages.
		///		If wMsgFilterMin and wMsgFilterMax are both zero, GetMessage returns all available messages (that is, no range filtering is performed). 
		/// </param>
		/// <returns>
		/// If the function retrieves a message other than  WM_QUIT, the return value is nonzero.
		/// If the function retrieves the WM_QUIT message, the return value is zero.
		/// If there is an error, the return value is -1.
		/// For example, the function fails if hWnd is an invalid window handle or lpMsg is an invalid pointer.
		/// To get extended error information, call GetLastError.
		/// </returns>
        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        static extern bool GetMessage(out MSG lpMsg, IntPtr hWnd, uint wMsgFilterMin, uint wMsgFilterMax);

		/// <summary>
		/// The MSG structure contains message information from a thread's message queue.
		/// </summary>
		[StructLayout(LayoutKind.Sequential)]
		public struct MSG
		{
			/// <summary>
			/// Handle to the window whose window procedure receives the message. hwnd is NULL when the message is a thread message.
			/// </summary>
			public IntPtr hwnd;

			/// <summary>
			/// Specifies the message identifier. Applications can only use the low word; the high word is reserved by the system.
			/// </summary>
			public UInt32 message;

			/// <summary>
			/// Specifies additional information about the message. The exact meaning depends on the value of the message member.
			/// </summary>
			public IntPtr wParam;

			/// <summary>
			/// Specifies additional information about the message. The exact meaning depends on the value of the message member.
			/// </summary>
			public IntPtr lParam;

			/// <summary>
			/// Specifies the time at which the message was posted.
			/// </summary>
			public UInt32 time;

			/// <summary>
			/// Specifies the cursor position, in screen coordinates, when the message was posted.
			/// </summary>
			public Point pt;
		}

        public const int WM_ENDSESSION = 0x0016;
        public const int WM_CLOSE = 0x0010;
        public const int WM_QUIT = 0x0012;

		#endregion WinAPI
	}
}
