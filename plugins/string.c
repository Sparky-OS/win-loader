/*
 *  string.c -- String handling functions
 *  Copyright (C) 2007,2009  Robert Millan <rmh@aybabtu.com>
 *  Copyright (C) 2011       Didier Raboud <odyx@debian.org>
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <windows.h>
#ifdef HAVE_EXDLL_H
#include "exdll.h"
#else
#include <nsis/pluginapi.h>
#endif

void __declspec (dllexport) bcdedit_extract_id (HWND hwndParent, int string_size, char *variables, stack_t ** stacktop, extra_parameters * extra)
{
  EXDLL_INIT ();

  char msg[1024];
  char *p = msg;

  popstring (msg);

  while (*p)
    {
      if (p[0] == '{' && p[37] == '}')
	{
	  p[38] = '\0';
	  pushstring (p);
	  return;
	}
      p++;
    }

  pushstring ("error");
}

void __declspec (dllexport) bcdedit_extract_partition (HWND hwndParent, int string_size, char *variables, stack_t ** stacktop, extra_parameters * extra)
{
  EXDLL_INIT ();

  char msg[4096];
  char *p = msg;

  popstring (msg);

  while (*p)
    {
      /* Ow, I'm really ashamed for that fat-and-dirty, but I don't know enough C to do that properly */
      if (p[0] == 'p' &&
	  p[1] == 'a' &&
	  p[2] == 'r' &&
	  p[3] == 't' &&
	  p[4] == 'i' &&
	  p[5] == 't' &&
	  p[6] == 'i' &&
	  p[7] == 'o' &&
	  p[8] == 'n' &&
	  p[9] == '=' &&
	  p[11] == ':')
	{
	  /* This selects: partition=C:
	                             ^^
	  */
	  p = p + 10;
	  p[2] = '\0';
	  pushstring (p);
	  return;
	}
      p++;
    }

  pushstring ("error");
}

BOOL WINAPI DllMain (HANDLE hInst, ULONG ul_reason_for_call, LPVOID lpReserved)
{
  return TRUE;
}
